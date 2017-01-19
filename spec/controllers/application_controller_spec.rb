require 'rails_helper'

describe ApplicationController do
  describe 'hello world' do
    specify { expect('hello world').to eq 'hello world' }
  end
end
