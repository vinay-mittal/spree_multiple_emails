Deface::Override.new(
  virtual_path: "spree/admin/users/_sidebar",
  name: "add_admin_user_emails_tab",
  insert_bottom: "[data-hook='admin_user_tab_options']",
  partial: "spree/admin/users/user_emails_tab"
)
