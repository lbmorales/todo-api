require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # initialize test data
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 10, created_by: user.id) }
  let(:todo_id) { todos.first.id }

  let(:headers) { valid_headers }

  # test suite for GET /todos
  describe 'GET /todos' do
    before { get '/todos', params: {}, headers: headers }

    it 'returns todos' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", params: {}, headers: headers }

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
      let(:todo_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Todo/) # Note: Este mensaje tiene que ser exactamente igual pq es lo que devuelve el servidor en el response
      end
    end
  end

  # Test suite for POST /todos
  describe 'POST /todos' do
    let(:valid_attributes) do
      { title: 'Lorem Ipsum', created_by: user.id.to_s }.to_json
    end

    context 'when the resquest is valid' do
      before { post '/todos', params: valid_attributes, headers: headers }

      it 'create a todo' do
        expect(json['title']).to eq('Lorem Ipsum')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the resquest in invalid' do
      let(:valid_attributes) { { title: nil }.to_json }
      before { post '/todos', params: valid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Shopping' }.to_json }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers }
      let(:todo_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exists' do
      let(:todo_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
