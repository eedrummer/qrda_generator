module QrdaGenerator
  module Export
    module Cat1
      include HealthDataStandards::Export::TemplateHelper
      include QME::Importer::EntryFilter

      def export(patient, measures, start_date, end_date)
        self.template_format = "cat1"
        render(:template => 'show', :locals => {:patient => patient, :measures => measures, 
                                                :start_date => start_date, :end_date => end_date})
      end

      def entries_for_data_criteria(data_criteria, patient)
        entries = filter_entries(data_criteria.standard_category, data_criteria.qds_data_type, patient)
        codes = ValueSetManager.codes_for_oid(data_criteria.code_list_id)
        filter_entries_by_codes(entries, codes) {|entry, matching_list| matching_list << entry}
      end

      extend self
    end
  end
end