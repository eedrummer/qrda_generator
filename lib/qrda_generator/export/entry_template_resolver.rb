module QrdaGenerator
  module Export
    module EntryTemplateResolver
      def hqmf_qrda_oid_map
        if @hqmf_qrda_oid_map.blank?
          template_id_file = File.expand_path('../hqmf-qrda-oids.json', __FILE__)
          @hqmf_qrda_oid_map = JSON.parse(File.read(template_id_file))  
        end
        @hqmf_qrda_oid_map
      end

      def qrda_oid_exist?(oid)
        hqmf_qrda_oid_map.any? {|map_tuple| map_tuple['qrda_oid'] == oid}
      end

      def qrda_oid_for_hqmf_oid(hqmf_oid)
        hqmf_qrda_oid_map.find {|map_tuple| map_tuple['hqmf_oid'] == hqmf_oid }['qrda_oid'] 
      end

      extend self
    end
  end
end