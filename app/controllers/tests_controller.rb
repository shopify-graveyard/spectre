require 'image_processor'
require 'net/http'
require 'tempfile'

class TestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @test = Test.new
  end

  def update
    @test = Test.find(params[:id])
    if params[:test][:baseline] == 'true'
      @test.pass = true
      @test.save
      redirect_to project_suite_run_url(@test.run.suite.project, @test.run.suite, @test.run)
    end
  end

  def create
    screenshot = test_params[:screenshot]

    if(screenshot.is_a?(String))
       url = URI.parse(screenshot)
       response = Net::HTTP.get_response(url)
       
       temp_file = Tempfile.new('test', :encoding => 'ascii-8bit')
       temp_file.write(response.body)
       
       http_file = ActionDispatch::Http::UploadedFile.new(tempfile: temp_file)
       http_file.content_type = response.content_type
      
       screenshot = http_file
    end

    ImageProcessor.crop(screenshot.path, test_params[:crop_area]) if test_params[:crop_area]
    @test = Test.create!(test_params.merge(screenshot: screenshot))
    ScreenshotComparison.new(@test, screenshot)
    render json: @test.to_json
  end

  private

  def test_params
    params.require(:test).permit(:name, :browser, :size, :screenshot, :run_id, :source_url, :fuzz_level, :highlight_colour, :crop_area)
  end
end
