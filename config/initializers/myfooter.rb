class MyFooter < ActiveAdmin::Component
  def build
    super(id: "footer")
    para "Copyright #{Date.today.year} World-Fax."
  end
end