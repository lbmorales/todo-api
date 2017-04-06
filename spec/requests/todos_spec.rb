require 'rails_helper'

RSpec.describe 'Todos API', :type :requests do
  # initialize test data
  let!(:todos) { create_list(:todo, 10)}
  let(:todo_id) { todos.first.id }

  # test suite for GET /todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get '/todos' }

    it 'returns todos' do
      # Note `json` is a custom helper to parse JSON responses
      # For json code see /spec/support/request_spec_helper.rb
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    before { get '/todos/#{todo_id}' }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 1000 } # Note: force todo_id = 1000, wich not exist, before create only 10

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Could't find Todo/)
      end
    end
  end

   # Test suite for POST /todos
  describe 'POST /todos' do
    # valid payload
    let(:valid_attributes) {{title: 'Lorem Ipsum', created_by: '1'}}

    context 'when the resquest is valid' do
      before { post '/todos', params: valid_attributes }

      it 'create a todo' do
        expect(json['title']).to eq('Lorem Ipsum')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the resquest in invalid' do
      before { post '/todos', params: { title: 'Foobar only title' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation message failure' do
        expect(response.body).to match(/Validation failure: Created by can't be blank/)
      end
    end
   end

   # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      expect(response.body).to be_empty
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  # Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before { delete '/todos/#{todo_id}'}

    it 'returns status code 204'
  end

end