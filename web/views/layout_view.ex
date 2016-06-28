defmodule VelocitasIdentity.LayoutView do
  use VelocitasIdentity.Web, :view

  def api_endpoint_url do
    System.get_env("CORE_API_URL")
  end

  def stoplights_url do
    "#{api_endpoint_url}/stoplights"
  end

  def commutes_url do
    "#{api_endpoint_url}/commutes"
  end
end
