module  ActiveAdmin

    module  Helpers

        module  Routes

            module  UrlHelpers

                include  Rails.application.routes.url_helpers

            end



            extend  UrlHelpers



            def  self.default_url_options

                Rails.application.config.action_mailer.default_url_options  ||  {}

            end

        end

    end

end

