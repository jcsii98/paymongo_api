class TestController < ApplicationController
    def test_api
        render json: { message: "Hello"}
    end
end