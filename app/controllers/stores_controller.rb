class StoresController < ApplicationController

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      redirect_to @store
    else
      render 'new'
    end
  end

end
