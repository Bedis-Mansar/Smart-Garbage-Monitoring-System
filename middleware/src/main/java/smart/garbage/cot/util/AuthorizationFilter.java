package smart.garbage.cot.util;
import jakarta.annotation.Priority;
import jakarta.annotation.security.RolesAllowed;
import jakarta.ws.rs.Priorities;
import jakarta.ws.rs.container.ResourceInfo;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.core.*;
import jakarta.ws.rs.ext.Provider;
import jakarta.ws.rs.core.Response;
import java.lang.reflect.Method;
import java.util.Base64;
@Provider
@Priority(Priorities.AUTHORIZATION)
public class AuthorizationFilter implements ContainerRequestFilter { // The authorization filter will block requests if the user's role is not permitted to access the resource.
    @Context
    private ResourceInfo resourceInfo;
    public final static String authorizePath = "/api/authorize";
    public final static String authenticatePath = "/api/authenticate/";
    public final static String tokenPath = "/api/oauth/token";
    public final static String personpath= "/api/user";
    public final static String authenticateadminPath = "/api/authenticateadmin/";
    public final static String forgottenpasswordpath= "/api/mail/";
    @Override
    public void filter(ContainerRequestContext requestContext) {
        Method method = resourceInfo.getResourceMethod();
        final String path = requestContext.getUriInfo().getRequestUri().getPath();
        if(path.equals(authorizePath)||path.equals(tokenPath)||path.equals(authenticatePath)||path.equals(personpath)||path.equals(authenticateadminPath)||path.contains(forgottenpasswordpath)){
            return; // if the request path is equal to the signin or signup paths, the request is allowed  without an access token
        }

        String authorizationHeader = requestContext.getHeaderString(HttpHeaders.AUTHORIZATION); // requests without valid authorization headers are blocked by the authentication token. Therefore, the authorization token is only active on tokens with headers
        RolesAllowed rolesAllowed=null;
        if (method!=null){
            rolesAllowed = method.getAnnotation(RolesAllowed.class); // get the declared variables in rolesallowed if it exists
            System.out.println(rolesAllowed);}
        System.out.println(method);
        System.out.println("ok");
        System.out.println(rolesAllowed);



        String authenticationToken = authorizationHeader.substring(7); // get access token from "Bearer accestoken"
        if (rolesAllowed != null) {//if the method is annotated with rolesallowed, perform authorize check
            if (Authorize(rolesAllowed.value(),authenticationToken)){
                System.out.println(rolesAllowed.value());
                return;}
            else {requestContext.abortWith(Response // if authorize check returns false, the user is blocked from accessing the request
                    .status(Response.Status.UNAUTHORIZED)
                    .entity("Only admins can access these resources!!!!")
                    .build());}
        }



        // Authorization is not required for non-annotated methods
    }


    private Boolean Authorize(String[] rolesAllowed,
                              String accessToken) {
        String jwt=new String(Base64.getDecoder().decode(accessToken.substring(accessToken.indexOf(".")+1,accessToken.lastIndexOf("."))));
        String jwtrole=jwt.substring(jwt.indexOf("groups")+10,jwt.indexOf("]")-1); // get the role of the users from jwt


        for (final String role : rolesAllowed) {
            System.out.println(role);
            System.out.println(jwtrole);
            if (jwtrole.equals(role)) { //if user's role is equal to one of the roles that exist in roles allowed, return true and allow request
                return true;
            }
        }

        return false;
    }
}


