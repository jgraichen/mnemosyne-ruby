# frozen_string_literal: true

module Mnemosyne
  module Probes
    module ActionController
      class ProcessAction < ::Mnemosyne::Probe
        subscribe 'process_action.action_controller'

        def call(trace, name, start, finish, id, payload)
          start  = ::Mnemosyne::Clock.to_tick(start)
          finish = ::Mnemosyne::Clock.to_tick(finish)

          meta = {
            controller: payload[:controller],
            action: payload[:action],
            format: payload[:format]
          }

          span = ::Mnemosyne::Span.new "rails.#{name}",
            start: start, finish: finish, meta: meta

          trace << span
        end
      end
    end

    register('ActionController::Base', 'action_controller', ActionController::ProcessAction.new)
  end
end
