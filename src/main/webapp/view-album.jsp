<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.musicvibe.domain.Track" %>
<%@ page import="com.svalero.musicvibe.dao.TrackDao" %>
<%@ page import="com.svalero.musicvibe.domain.Album" %>
<%@ page import="com.svalero.musicvibe.dao.AlbumDao" %>
<%@ page import="static com.svalero.musicvibe.util.DateUtils.convertSecondsToMinutes" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp" %>

<script type="text/javascript">
    function deleteTrack(id, id_album) {
        $.ajax("edit-track?id_track=" + id, {
            type: "GET",
            statusCode: {
                200: function (response) {
                    if (response === "ok") {
                        window.location.href = "/MusicVibe/view-album.jsp?id=" + id_album;
                    } else {
                        $("#result").html(response);
                    }
                }
            }
        });
    }
</script>

<main>
  <%
    int id;
    if (request.getParameter("id") != null)
      id = Integer.parseInt(request.getParameter("id"));
    else {
      id = 0;
    }
  %>

  <%
    String search;
    if (request.getParameter("search") != null)
      search = request.getParameter("search");
    else {
      search = "";
    }
  %>

  <%
    Database.connect();
    Album album = Database.jdbi.withExtension(AlbumDao.class, dao -> dao.getAlbum(id));
    List<Track> tracks = null;

    if (search.isEmpty()) {
      tracks = Database.jdbi.withExtension(TrackDao.class, dao -> dao.getAllTracks(id));
    } else {
      final String searchTerm = '%' + search + '%';
      tracks = Database.jdbi.withExtension(TrackDao.class, dao -> dao.getAllTrackBySearch(searchTerm, id));
    }
  %>

  <div class="container">

    <div class="row g-0 text-center my-3 align-items-center">
      <div class="col-md-4">
        <img src="../musicvibe-picture/<%= album.getPicture()%>" onerror="'this.onerror=null'; this.src='../musicvibe-picture/no-image.jpg';" class="rounded-circle" style="height: 300px"/>
      </div>

      <div class="col-md-8">
        <p class="display-4"><%= album.getName() %></p>
        <p>
          <%
            if (role.equals("admin")) {
          %>
          <a href="edit-track.jsp?id_album=<%= id %>" class="btn btn-success my-2">Registrar nueva Canción</a>
          <%
            }
          %>
        </p>
      </div>
    </div>

    <form class="row g-2" id="search-form" method="GET">
      <div class="input-group mb-3">
        <input type="hidden" name="id" value="<%= id %>"/>
        <input type="text" class="form-control" placeholder="Buscar en Canciones " name="search" id="search-input"
          <% if (!search.isEmpty()) { %> value="<%=search%>"<% } %>>
        <button type="submit" class="btn btn-outline-success" id="search-button">Buscar Canción</button>
      </div>
    </form>
  </div>

  <div class="container">
    <table class="table text-center align-items-center">
      <tbody>
        <%
          for (Track track : tracks) {
        %>
      <tr>
        <td><%=track.getName()%></td>
        <td><%=convertSecondsToMinutes(track.getDuration())%></td>
        <td>
          <audio src="../musicvibe-picture/<%=track.getAudio()%>" controls>
          Your browser does not support the <code>audio</code> element.
          </audio>
        </td>
        <%
          if (role.equals("admin")) {
        %>
        <td>
          <a href="edit-track.jsp?id_track=<%=track.getId_track()%>" type="button"
               class="btn btn-sm btn-outline-secondary">Editar</a>
        </td>
        <td>
          <button class="btn btn-sm btn-outline-danger" onclick="deleteTrack(<%=track.getId_track()%>, <%=id%>)">
            Eliminar
          </button>
        </td>
        <%
          }
        %>
      </tr>
        <%
          }
        %>
      </tbody>
    </table>
  </div>
  <div class="fixed-bottom w-25" id="result"></div>
</main>

<%@include file="includes/footer.jsp" %>