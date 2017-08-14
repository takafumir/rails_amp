# Just for test.
class UsersController < ApplicationController
  def index
    redirect_to root_path if params['redirect_test'].to_s == "true"
  end

  def show
  end

  def trailing_slash
    render layout: 'trailing_slash'
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
