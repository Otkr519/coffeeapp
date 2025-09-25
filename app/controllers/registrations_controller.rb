class RegistrationsController < Devise::RegistrationsController
  def destroy
    if resource.email == "guest@example.com"
      redirect_to root_path, alert: "ゲストユーザーは退会できません。"
    else
      super
    end
  end
end
