require "rails_helper"

RSpec.describe "Tasks", type: :request do
  def create_user(email)
    User.create!(email: email, password: "password123", username: email.split("@").first)
  end

  let(:owner) { create_user("owner@example.com") }
  let(:other_user) { create_user("other@example.com") }
  let!(:task) do
    owner.tasks.create!(title: "Owner's task", body: "Original body", description: "Original", visibility: 0)
  end

  describe "creating a task" do
    it "saves the task for the signed-in user" do
      sign_in owner

      expect {
        post tasks_path, params: { task: { title: "New task", body: "Some notes" } }
      }.to change(owner.tasks, :count).by(1)
    end

    it "sends a signed-out visitor to the sign-in page" do
      expect {
        post tasks_path, params: { task: { title: "New task", body: "Some notes" } }
      }.not_to change(Task, :count)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "as the task's owner" do
    before { sign_in owner }

    it "shows the edit page" do
      get edit_task_path(task)

      expect(response).to have_http_status(:ok)
    end

    it "updates the task" do
      patch task_path(task), params: { task: { title: "Changed" } }

      expect(response).to redirect_to(task_path(task))
      expect(task.reload.title).to eq("Changed")
    end

    it "deletes the task" do
      expect { delete task_path(task) }.to change(Task, :count).by(-1)
    end
  end

  describe "as a different signed-in user" do
    before { sign_in other_user }

    it "does not show the edit page" do
      get edit_task_path(task)

      expect(response).to have_http_status(:not_found)
    end

    it "does not update the task" do
      patch task_path(task), params: { task: { title: "Hijacked" } }

      expect(response).to have_http_status(:not_found)
      expect(task.reload.title).to eq("Owner's task")
    end

    it "does not delete the task" do
      expect { delete task_path(task) }.not_to change(Task, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "when signed out" do
    it "does not update the task" do
      patch task_path(task), params: { task: { title: "Hijacked" } }

      expect(response).to redirect_to(new_user_session_path)
      expect(task.reload.title).to eq("Owner's task")
    end

    it "does not delete the task" do
      expect { delete task_path(task) }.not_to change(Task, :count)

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "viewing a private task" do
    before { task.update!(visibility: 2) }

    it "shows it to the owner" do
      sign_in owner
      get task_path(task)

      expect(response.body).to include("Original body")
    end

    it "hides it from another user" do
      sign_in other_user
      get task_path(task)

      expect(response.body).not_to include("Original body")
      expect(response.body).to include("You do not have permission to view this task")
    end
  end
end
