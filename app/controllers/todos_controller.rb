class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]
  # GET /todos
  def index
    # get current user todos
    @todos = current_user.todos
    json_response(@todos) # json_response is a helper writed by me, see: controllers/concerns/response.rb
  end

  # POST /todos
  def create
     # create todos belonging to current user
    @todo = current_user.todos.create!(todo_params)
    json_response(@todo, :created)
  end

  # GET /todos/:id
  def show
    json_response(@todo)
  end

  # PUT /todos/:id
  def update
    @todo.update(todo_params)
    head :no_content
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def todo_params
    # white list params
    params.permit(:title)
  end

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end
end
