# frozen_string_literal: true

module Http
  module Exception
    class Handler
      @logger = Logeable::Logger.new('log/error.log', Logger::ERROR)

      def self.handle(exception, context)      
        case exception
        when Http::Exception::NotFound
          @logger.write(:error, "Not found for #{context.name}")
          context.fail!(
            error: I18n.t('api.v1.errors.not_found', name: context.name), 
            status_code: :not_found
          )
        else
          @logger.write(:error, "Unknown exception: #{exception.message}")
          context.fail!(
            error: exception.message,
            status: :internal_server_error
          )
        end
      end
    end
  end
end