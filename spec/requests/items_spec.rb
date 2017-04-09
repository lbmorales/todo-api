require 'rails_helper'

RSpec.describe 'Items API' do
  # Initialize  the test data
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }

  # Test suit for GET /todos/:todo_id/items
  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    context 'when the todo exists' do
      it 'returns all todo items' do
        expect(json.size).to eq(20)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when todo does not exists' do
      let(:todo_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Could't find todo/)
      end
    end
  end

  # Test suit for GET /todos/:todo_id/items/:item_id
  describe '/todos/:todo_id/items/:id' do # ????????????? no necesito probar aqui que el todo existe???
    before { get "/todos/#{todo_id}/items/#{id}" }

    context 'when todo item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item ' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when todo item does not exists' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Tests suit for POST /todos/:todo_id/items
  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) { { name: 'Visit cancun', done: 'False' } }

    context 'when request attributes are valid' do
      before { post "/todos/#{todo_id}/items", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      # it 'create a item' do
      #     expect(json['title']).to eq('Visit cancun')
      # end
    end

    context 'when request is invalid' do
      before { post "/todos/#{todo_id}/items", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation faliled: Name can't be blank/)
      end
    end
  end

  # Test suit for PUT /todos/:todo_id/items/:id
  describe 'PUT /todos/:todo_id/items/:id' do
    let(:valid_attributes) { { name: 'Mozart' } }
    before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes }

    context 'when item exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the item' do
        updated_item = Item.find(id)
        expect(updated_item.name).to match(/Mozart/)
      end
    end

    context 'when item does not exists' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not foun message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suit for DELETE /todos/:todo_id/items/:id
  describe 'DELETE /todos/:todo_id/items/:id' do
    before { delete "/todos/#{todo_id}/items/#{id}" }

    context 'when record exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when record does not exists' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
end
