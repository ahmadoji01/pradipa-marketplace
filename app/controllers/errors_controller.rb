class ErrorsController < ApplicationController
    layout 'error'

    def not_found
        render status: 404
    end

    def unprocessable_entity
        render status: 422
    end
    
    def server_error
        render status: 500
    end
end