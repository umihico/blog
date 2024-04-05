---
tags: "Ruby on Rails"
date: '2022-12-22'
---

# ControllerにincludeしてるConcernを単体テストする

routesとcontrollerをモックすることで、includeしたControllerとしてテストするのではなく単体テストが実現できました。

## Concernを用意

例として署名による検証です。

```ruby
module SignatureAuthenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_signature

    private

      def authenticate_signature
        return unless invalid_signature?

        render json: { result: "Invalid signature"}, status: :unauthorized
      end

      def invalid_signature?
        generated = params.except("signature").sort.map { |_k, e| stringify(e) }.join
        secret_key = "hogehoge"
        Digest::SHA256.hexdigest("#{secret_key}#{generated}") != params[:signature]
      end
  end
end
```

## Rspecを用意

```ruby
require "rails_helper"

describe SignatureAuthenticable do
  # コントローラーをモック
  controller(ApplicationController) do
    include SignatureAuthenticable # rubocop:disable RSpec/DescribedClass https://github.com/rubocop/rubocop-rspec/issues/795

    def fake_action
      render json: { message: "ok" }
    end
  end

  before do
    # ルーティングをモック
    routes.draw do
      post "fake_action" => "anonymous#fake_action"
    end
    # モックされたルーティングにpost
    post :fake_action, params:
  end

  context "when signature is invalid" do
    let(:params) { { signature: SecureRandom.hex, a: SecureRandom.hex, b: SecureRandom.hex } }

    it do
      expect(json).to eq({ "result" => "Invalid signature" })
    end
  end

  context "when signature is valid" do
    let(:raw_params) { { a: SecureRandom.hex, b: SecureRandom.hex } }
    let(:signature) { Digest::SHA256.hexdigest("hogehoge#{raw_params.except("signature").sort.map { |_k, e| stringify(e) }.join}") }
    let(:params) { { signature:, **raw_params } }
    
    it do
      expect(json).to eq({ "message" => "ok" })
    end
  end
end
```
