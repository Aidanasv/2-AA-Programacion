<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.svalero.musicvibe.domain.Artist" %>
<%@ page import="java.util.List" %>
<%@ page import="com.svalero.musicvibe.dao.ArtistsDao" %>
<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="com.svalero.musicvibe.domain.Artist" %>

<%@include file="includes/header.jsp" %>

<script type="text/javascript">
    function deleteArtist(id) {
        $.ajax("edit-artist?id_artist=" + id, {
            type: "GET",
            statusCode: {
                200: function (response) {
                    if (response === "ok") {
                        window.location.href = "/MusicVibe";
                    } else {
                        $("#result").html(response);
                    }
                }
            }
        });
    }
</script>

<main>
  <section class="py-5 text-center container">
    <div class="row py-lg-5">
      <div class="col-lg-6 col-md-8 mx-auto">
        <h1 class="fw-light">Music Vibe</h1>
        <p class="lead text-body-secondary">Artistas</p>
        <p>
          <%
            if (role.equals("admin")) {
          %>
          <a href="edit-artist.jsp" class="btn btn-success my-2">Registrar nuevo Artista</a>
          <%
            }
          %>
        </p>
      </div>
    </div>
  </section>

  <div class="album py-5 bg-body-tertiary">
    <div class="container">
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
          <input type="text" class="form-control" placeholder="Buscar en Artistas " name="search" id="search-input"
              <% if (!search.isEmpty()) { %> value="<%= search %>"<% } %>>
          <button type="submit" class="btn btn-outline-success" id="search-button">Buscar Artista</button>
        </div>
      </form>

      <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
        <%
          Database.connect();
          List<Artist> artists = null;
          if (search.isEmpty()) {
              artists = Database.jdbi.withExtension(ArtistsDao.class, dao -> dao.getAllArtists());
          }else {
              final String searchTerm = '%' + search + '%';
              artists = Database.jdbi.withExtension(ArtistsDao.class, dao -> dao.getAllArtistsBySearch(searchTerm));
          }
          for (Artist artist : artists) {
        %>

        <div class="col">
          <div class="card shadow-sm bg-black text-white px-4 pt-4">
            <img src="../musicvibe-picture/<%= artist.getPicture()%>" onerror="'this.onerror=null'; this.src='../musicvibe-picture/no-image.jpg';" height="450px"/>
            <div class="card-body">
              <p class="card-text fs-3"><strong><%=artist.getName()%>
              </strong></p>
              <p class="card-text"><%=artist.getGenre()%>
              </p>
              <div class="d-flex justify-content-between align-items-center">
                <div>
                  <a href="view-artist.jsp?id=<%=artist.getId()%>" type="button"
                     class="btn btn-sm btn-success">Ver</a>
                  <%
                    if (role.equals("admin")) {
                  %>
                  <a href="edit-artist.jsp?id=<%=artist.getId()%>" type="button"
                     class="btn btn-sm btn-outline-secondary">Editar</a>
                  <button class="btn btn-sm btn-outline-danger" onclick="deleteArtist(<%=artist.getId()%>)">
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
  </div>
</main>

<%@include file="includes/footer.jsp" %>
