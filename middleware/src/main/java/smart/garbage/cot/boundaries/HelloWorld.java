package smart.garbage.cot.boundaries;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.core.Response;
@Path("/echoes")
public class HelloWorld {
    @GET
    @Path("/{name}")
    public Response getClichedMessage(@PathParam("name") String name){
        return Response.ok().entity("{\"message\":\"Hello " + name + "!\"}").build();
    }


}
