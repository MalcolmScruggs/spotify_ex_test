defmodule SpotifyExTest.PlaylistController do
  use SpotifyExTest.Web, :controller
  plug :check_tokens

  def index(conn, _params) do
    case Spotify.Playlist.current_user_playlists(conn) do
      { 200, playlists } ->
        render conn, "index.html", playlists: playlists
        :authorize -> redirect conn, external: Spotify.Authorization.url
    end
  end

  defp check_tokens(conn, _params) do
    unless Spotify.Authentication.tokens_present?(conn) do
      redirect conn, to: authorization_path(conn, :authorize)
    end
    conn
  end
end