Deface::Override.new(
  virtual_path: "spree/users/show",
  name: "add_user_emails_to_user_account",
  insert_after: "[data-hook='account_summary']",
  partial: "spree/users/my_emails"
)
