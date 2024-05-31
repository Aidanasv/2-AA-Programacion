<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="com.svalero.musicvibe.domain.Artist" %>
<%@ page import="com.svalero.musicvibe.dao.ArtistsDao" %>
<%@ page import="com.svalero.musicvibe.domain.Album" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.musicvibe.dao.AlbumDao" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp" %>

<script type="text/javascript">
    function deleteAlbum(id, id_artist ) {
        $.ajax("edit-album?id_album=" + id, {
            type: "GET",
            statusCode: {
                200: function (response) {
                    if (response === "ok") {
                        window.location.href = "/MusicVibe/view-artist.jsp?id=" + id_artist;
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
    int id = Integer.parseInt(request.getParameter("id"));

    Database.connect();
    Artist artist = Database.jdbi.withExtension(ArtistsDao.class, dao -> dao.getArtist(id));
  %>

  <div class="container">
    <div class="row g-0 text-center my-3 align-items-center">
      <div class="col-md-4">
        <img src="../musicvibe-picture/<%= artist.getPicture()%>" onerror="'this.onerror=null'; this.src='../musicvibe-picture/no-image.jpg';" class="rounded-circle" style="height: 300px"/>
      </div>

      <div class="col-md-8">
        <p class="display-2"><%= artist.getName() %></p>
        <p>
          <%
            if (role.equals("admin")) {
          %>
          <a href="edit-album.jsp?id=<%=artist.getId()%>" class="btn btn-success my-2">Registrar nuevo Álbum</a>
          <%
            }
          %>
        </p>
      </div>
    </div>

    <%
      String search;
      if (request.getParameter("search") != null)
        search = request.getParameter("search");
      else {
        search = "";
      }
    %>

    <form class="row g-2" id="search-form" method="GET">
      <div class="input-group mb-3">
        <input type="hidden" name="id" value="<%= id %>"/>
        <input type="text" class="form-control" placeholder="Buscar en Álbumes " name="search" id="search-input"
          <% if (!search.isEmpty()) { %> value="<%= search %>"<% } %>>
        <button type="submit" class="btn btn-outline-success" id="search-button">Buscar Álbum</button>
      </div>
    </form>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-3">
      <%
        Database.connect();
        List<Album> albums = null;
        if (search.isEmpty()) {
          albums = Database.jdbi.withExtension(AlbumDao.class, dao -> dao.getAlbumByArtist(id));
        }else {
          final String searchTerm = '%' + search + '%';
          albums = Database.jdbi.withExtension(AlbumDao.class, dao -> dao.getAllAlbumBySearch(searchTerm, id));
        }
        for (Album album : albums) {
      %>

      <div class="col">
        <div class="card shadow-sm bg-black text-white px-4 pt-4">
          <img src="../musicvibe-picture/<%= album.getPicture()%>" onerror="'this.onerror=null'; this.src='../musicvibe-picture/no-image.jpg';" style="height: 300px"/>
          <div class="card-body">
            <p class="card-text fs-4"><strong><%=album.getName()%>
            </strong></p>
            <p class="card-text"><%=album.getRelease_date()%></p>
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <a href="view-album.jsp?id=<%=album.getId_album()%>" type="button"
                   class="btn btn-sm btn-success">Ver</a>
                <%
                  if (role.equals("admin")) {
                %>
                <a href="edit-album.jsp?id_album=<%=album.getId_album()%>" type="button"
                   class="btn btn-sm btn-outline-secondary">Editar</a>
                <button class="btn btn-sm btn-outline-danger" onclick="deleteAlbum(<%=album.getId_album()%>,<%=id%>)">
                  Eliminar
                </button>
                <%
                  }
                %>
              </div>
            </div>
          </div>
        </div>
      </div>

      <%
        }
      %>
    </div>
  </div>
  <div class="fixed-bottom w-25" id="result"></div>
</main>

<%@include file="includes/footer.jsp" %>