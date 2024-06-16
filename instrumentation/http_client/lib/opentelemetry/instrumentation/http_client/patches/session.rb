# frozen_string_literal: true

# Copyright The OpenTelemetry Authors
#
# SPDX-License-Identifier: Apache-2.0

module OpenTelemetry
  module Instrumentation
    module HttpClient
      module Patches
        # Module to prepend to HTTPClient::Session for instrumentation
        module Session
          def connect
            site = @proxy || @dest
            url = site.addr

            attributes = {
              OpenTelemetry::SemanticConventions::Trace::HTTP_URL => url,
              'url.full' => url
            }.merge!(OpenTelemetry::Common::HTTP::ClientContext.attributes)
            tracer.in_span('HTTP CONNECT', attributes: attributes) do
              super
            end
          end

          private

          def tracer
            HttpClient::Instrumentation.instance.tracer
          end
        end
      end
    end
  end
end
