module Test
  module ControllerHelpers
    def json_data
      JSON.parse(response.body.to_s)
    end
  end
end
