module MWS
  module API
    # Feeds
    class Feeds < Base
      XSD_PATH = File.join(File.dirname(__FILE__), 'feeds', 'xsd')

      ACTIONS = [:get_feed_submission_list, :get_feed_submission_list_by_next_token,
                 :get_feed_submission_count, :cancel_feed_submissions, :get_feed_submission_result].freeze

      def initialize(connection)
        @uri = '/'
        @version = '2009-01-01'
        @verb = :post
        super
      end

      def submit_feed(params = {})
        xml_envelope = Envelope.new(params.merge!(merchant_id: connection.seller_id))
        params = params.except(:merchant_id, :message_type, :message, :messages, :skip_schema_validation)
        call(:submit_feed, params.merge!(
                             request_params: {
                               format: :xml,
                               headers: { 'Content-MD5' => xml_envelope.md5, 'Content-Type' => 'text/xml' },
                               body: xml_envelope.to_s
                             }
        ))
      end
    end
  end
end
