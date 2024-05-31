<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.musicvibe.domain.Playlist" %>
<%@ page import="com.svalero.musicvibe.dao.PlaylistDao" %>
<%@ page import="com.svalero.musicvibe.domain.AlbumTracksArtist" %>
<%@ page import="com.svalero.musicvibe.dao.AlbumTracksArtistDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp" %>

<script type="text/javascript">
    //Añadir playlist
    $(document).ready(function () {
        $("#addPlaylist").click(function (event) {
            event.preventDefault();
            const form = $("#form-playlist")[0];
            const data = new FormData(form);

            $("#addPlaylist").prop("disabled", true);

            $.ajax({
                type: "POST",
                enctype: "multipart/form-data",
                url: "view-playlist",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                success: function (data) {
                    $("#result").html(data);
                    $("#addPlaylist").prop("disabled", false);
                    window.location.href = "/MusicVibe/view-playlists.jsp";
                },
                error: function (error) {
                    $("#result").html(error.responseText);
                    $("#addPlaylist").prop("disabled", false);
                }
            });
        });
    });

    //Eliminar playlist
    function deletePlaylist(id) {
        $.ajax("view-playlist?id_playlist=" + id, {
            type: "GET",
            statusCode: {
                200: function (response) {
                    if (response === "ok") {
                        window.location.href = "/MusicVibe/view-playlists.jsp";
                    } else {
                        $("#result").html(response);
                    }
                }
            }
        });
    }

    //Eliminar canción de una playlist
    function deleteTrackFromPlaylist(id_track, id_playlist) {
        $.ajax("edit-playlist?id_playlist=" + id_playlist + "&id_track=" + id_track, {
            type: "GET",
            statusCode: {
                200: function (response) {
                    if (response === "ok") {
                        window.location.href = "/MusicVibe/view-playlists.jsp?id_playlist=" + id_playlist;
                    } else {
                        $("#result").html(response);
                    }
                }
            }
        });
    }

    //Añadir canción a una playlist
    function addTrackIntoPlaylist(id_track, id_playlist) {
        $.ajax("edit-playlist?id_playlist=" + id_playlist + "&id_track=" + id_track, {
            type: "POST",
            statusCode: {
                200: function (response) {
                    if (response === "ok") {
                        window.location.href = "/MusicVibe/view-playlists.jsp?id_playlist=" + id_playlist;
                    } else {
                        $("#result").html(response);
                    }
                }
            }
        });
    }

    //Seleccionar una playlist
    function selectPlaylist() {
        var id = document.getElementById("select").value;
        window.location.href = "/MusicVibe/view-playlists.jsp?id_playlist=" + id;
    }

    //Reproducir audio
    function playAudio(id_track) {
        var audio = document.getElementById('audio' + id_track);
        var playIcon = document.getElementById('play' + id_track);

        if (audio.paused) {
            audio.play();
            playIcon.src = 'icons/pause.png'
        } else {
            audio.pause();
            playIcon.src = 'icons/play.png'
        }
    }
</script>

<main>
  <%
    int id_playlist;
    if (request.getParameter("id_playlist") != null)
      id_playlist = Integer.parseInt(request.getParameter("id_playlist"));
    else {
      id_playlist = 0;
    }
  %>


  <%
    Database.connect();
    List<Playlist> playlists = Database.jdbi.withExtension(PlaylistDao.class, dao -> dao.getAllPlaylist((id_user)));
  %>

  <section class="py-5 text-center container">
    <div class="row py-lg-5">
      <div class="col-lg-6 col-md-8 mx-auto">
        <h1 class="fw-light">Mis Playlists</h1>
          <%
            if (!role.equals("annonymous")) {
          %>
        <div class="row g-3 justify-content-evenly mt-3">
          <div class="col-auto">
            <select onchange="selectPlaylist()" class="form-select" aria-label="Default select example" id="select">
              <option value="0" <%
                if (id_playlist == 0){ %>
                  selected<%}%>>Seleccionar playlist</option>
              <%
                for (Playlist playlist : playlists) {
              %>
                <option value="<%= playlist.getId_playlist() %>" <%
                  if (id_playlist == playlist.getId_playlist()){ %>
                        selected<%}%>><%= playlist.getName() %></option>
              <%
                }
              %>
            </select>
          </div>

          <div class="col-auto">
            <button type="button" class="btn btn-outline-success my-2" data-bs-toggle="modal" data-bs-target="#exampleModal" data-bs-whatever="@mdo">Crear Playlist</button>
            <button type="button" class="btn btn-outline-danger my-2" onclick="deletePlaylist(<%=id_playlist%>)">Eliminar Playlist</button>

          </div>
        </div>
          <%
            }
          %>
      </div>
    </div>
  </section>

  <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h1 class="modal-title fs-5" id="exampleModalLabel">Crear nueva Playlist</h1>
        </div>
        <div class="modal-body">
          <form id="form-playlist">
            <div class="mb-3">
              <label for="recipient-name" class="col-form-label">Nombre</label>
              <input type="text" class="form-control" id="recipient-name" name="name">
              <input type="hidden" name="id_user" value="<%= id_user %>"/>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" class="btn btn-primary" id="addPlaylist">Guardar</button>
        </div>
      </div>
    </div>
  </div>

  <%
    List<AlbumTracksArtist> allTracks =  Database.jdbi.withExtension(AlbumTracksArtistDao.class, dao -> dao.getAllAlbumTracksArtist(id_playlist));
    List<AlbumTracksArtist> tracksPlaylists =  Database.jdbi.withExtension(AlbumTracksArtistDao.class, dao -> dao.getAllAlbumTracksArtistByPlaylist(id_playlist));
  %>

  <div class="container">
    <div class="row" style="height:500px">
      <div class="col-6 overflow-y-auto" style="height:500px">
        <table class="table">
          <thead>
          <tr>
            <th scope="col"></th>
            <th scope="col">Canción</th>
            <th scope="col">Artista</th>
            <th scope="col">Álbum</th>
            <th scope="col"></th>
          </tr>
          </thead>
          <tbody>
          <%
            for (AlbumTracksArtist trackPlaylist : tracksPlaylists) {
          %>
          <tr>

            <td >
              <div style="background-image: url('../musicvibe-picture/<%= trackPlaylist.getAlbumPicture()%>'); background-size: cover;background-repeat: no-repeat;width:50px;height:50px">
                <img id="play<%=trackPlaylist.getIdTrack()%>" onclick="playAudio(<%=trackPlaylist.getIdTrack()%>)"  src="icons/play.png" width="50px" height="50px" />

              </div>
            </td>

            <td><%=trackPlaylist.getNameTrack()%></td>
            <td><%=trackPlaylist.getArtistName()%></td>
            <td><%=trackPlaylist.getAlbumName()%></td>
            <td style="display: none">
              <audio id="audio<%=trackPlaylist.getIdTrack()%>" src="../musicvibe-picture/<%=trackPlaylist.getAudioTrack()%>" controls>
              Your browser does not support the <code>audio</code> element.
              </audio>
            </td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteTrackFromPlaylist(<%=trackPlaylist.getIdTrack()%>,<%= id_playlist %>)">Eliminar</button>
            </td>
          </tr>
          <%
            }
          %>
          </tbody>
        </table>
      </div>

      <div class="col-6 overflow-y-auto" style="height:500px">
        <table class="table">
          <thead>
          <tr>
            <th scope="col"></th>
            <th scope="col">Canción</th>
            <th scope="col">Artista</th>
            <th scope="col">Álbum</th>
            <th scope="col"></th>
          </tr>
          </thead>
          <tbody>
          <%
            for (AlbumTracksArtist track : allTracks) {
          %>
          <tr>
            <td >
              <div style="background-image: url('../musicvibe-picture/<%= track.getAlbumPicture()%>'); background-size: cover;background-repeat: no-repeat;width:50px;height:50px" >
                <img  id="play<%=track.getIdTrack()%>" onclick="playAudio(<%=track.getIdTrack()%>)"  src="icons/play.png" onerror="'this.onerror=null'; this.src='../musicvibe-picture/no-image.jpg';" width="50px" height="50px" />

              </div>
            </td>
            <td><%=track.getNameTrack()%></td>
            <td><%=track.getArtistName()%></td>
            <td><%=track.getAlbumName()%></td>
            <td style="display: none">
              <audio id="audio<%=track.getIdTrack()%>" src="../musicvibe-picture/<%=track.getAudioTrack()%>" controls>
                Your browser does not support the <code>audio</code> element.
              </audio>
            </td>
            <td>
              <button type="button" class="btn btn-sm btn-outline-success" onclick="addTrackIntoPlaylist(<%=track.getIdTrack()%>,<%= id_playlist %>)">Añadir</button>
            </td>
          </tr>
          <%
            }
          %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="fixed-bottom w-25" id="result"></div>
</main>

<%@include file="includes/footer.jsp" %>