<%@ page import="com.svalero.musicvibe.domain.Artist" %>
<%@ page import="com.svalero.musicvibe.dao.Database" %>
<%@ page import="com.svalero.musicvibe.dao.ArtistsDao" %>
<%@ page import="com.svalero.musicvibe.domain.Artist" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@include file="includes/header.jsp" %>

<script>
    $(document).ready(function () {
        $("#edit-button").click(function (event) {
            event.preventDefault();
            const form = $("#edit-form")[0];
            const data = new FormData(form);

            $("#edit-button").prop("disabled", true);

            $.ajax({
                type: "POST",
                enctype: "multipart/form-data",
                url: "edit-artist",
                data: data,
                processData: false,
                contentType: false,
                cache: false,
                timeout: 600000,
                success: function (data) {
                    $("#result").html(data);
                    $("#edit-button").prop("disabled", false);
                },
                error: function (error) {
                    $("#result").html(error.responseText);
                    $("#edit-button").prop("disabled", false);
                }
            });
        });
    });
</script>

<%
  if (!role.equals("admin")) {
    response.sendRedirect("/MusicVibe");
  }

  int id;
  Artist artist = null;
  if (request.getParameter("id") == null) {
    id = 0;
  } else {
    id = Integer.parseInt(request.getParameter("id"));
    Database.connect();
    artist = Database.jdbi.withExtension(ArtistsDao.class, dao -> dao.getArtist(id));
  }
%>

<main>
  <section class="py-5 container">
    <% if (id == 0) {%>
    <h1>Registrar nuevo Artista</h1>
    <% } else {%>
    <h1>Modificar Artista</h1>
    <% } %>

    <form class="row g-3 needs-validation" method="post" enctype="multipart/form-data" id="edit-form">
      <div class="mb-3">
        <label for="name" class="form-label">Nombre</label>
        <input type="text" name="name" class="form-control" id="name" placeholder="Ir a caminar"
          <% if (id != 0) { %> value="<%= artist.getName() %>"<% } %>>
      </div>

      <div class="input-group mb-3">
        <label class="input-group-text" for="inputGroupSelect01">Género</label>
        <select class="form-select" id="inputGroupSelect01" name="genre">
          <option <% if (id != 0) { %> value="<%= artist.getGenre() %>" selected>
            <%=artist.getGenre()%>
            <% } else {%>
            Género de Artista
            <%}%>
          </option>
          <option value="Pop">Pop</option>
          <option value="Rock">Rock</option>
          <option value="Hip Hop / Rap">Hip Hop / Rap</option>
          <option value="R&B">R&B</option>
          <option value="Electronic / Dance">Electronic / Dance</option>
          <option value="Latin">Latin</option>
          <option value="Country">Country</option>
          <option value="K-Pop">K-Pop</option>
          <option value="Jazz">Jazz</option>
          <option value="Classical">Classical</option>
        </select>
      </div>

      <div class="col-md-4">
        <label for="picture" class="form-label">Foto</label>
        <input type="file" name="picture" class="form-control" id="picture"
          <% if (id != 0) { %> value="<%= artist.getPicture() %>"<% } %>>
      </div>

      <div class="col-12">
        <input type="submit" class="btn btn-success" value="Enviar" id="edit-button"/>
        <a class="btn btn-success" href="index.jsp">Volver</a>
      </div>
      <input type="hidden" name="id_artist" value="<%= id %>"/>
    </form>
    <br>
    <div id="result" class="w-25"></div>
  </section>
</main>

<%@include file="includes/footer.jsp" %>