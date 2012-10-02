module HealthDataStandards
  module Export
    module TemplateHelper
      # Hack to override the template_root in Health Data Standards,
      # which will only reference templates in the Health Data Standard
      # gem
      def template_root
        File.join(File.dirname(__FILE__), '..', '..', '..', 'templates')
      end
    end
  end
end