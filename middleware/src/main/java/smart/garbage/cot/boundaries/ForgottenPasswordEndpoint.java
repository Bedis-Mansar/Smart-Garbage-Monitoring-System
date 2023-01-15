package smart.garbage.cot.boundaries;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import smart.garbage.cot.entities.User;
import smart.garbage.cot.repositories.UserRepository;
import smart.garbage.cot.util.Argon2Utility;

import java.util.Properties;

@ApplicationScoped
@Path("mail") //Path used when a user forgot his password and wants to change it to a new one
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ForgottenPasswordEndpoint {
    private final Map<String, String> verifcodes = new HashMap<>(); // hashmap to store verification codes
    @Inject
    private UserRepository repository; // get user methods to interact with database
    @GET
    @Path("/{mail}") // the user that wants to change his password sends a get request to get a verification code
    public void mail(@PathParam("mail") String mail) {
        final String username = "smart.garbagecot@gmail.com"; //mail of the application
        final String password = "nvkosscjandibldl"; // password of the application

        Properties props = new Properties(); // configuration for the simple mail transfer protocol
        props.put("mail.smtp.auth", true);
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.smtp.starttls.enable", true);
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
                new jakarta.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() { // connect to the application mail
                        return new PasswordAuthentication(username, password);
                    }
                }
        );

        try {
            Message message = new MimeMessage(session); // create new mail
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(mail));
            message.setSubject("Changing Password"); // object of the mail
            String code = UUID.randomUUID().toString(); //generate verification code
            message.setText("Greetings, you have recently demanded to change password. Here is your verification code. Tap it so you can change your password: " + code);
            Transport.send(message); //send message
            System.out.println("message sent"); // for debugging
            verifcodes.put(code, mail); // put the mail and the corresponding verification code in the hashmap
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
    @POST
    @Path("/{code}") // the user then sends the verification code alongside a new password
    public Response Respond(@PathParam("code") String code) {//
        if (verifcodes.containsKey(code)) {//if the verification code exists in the hashmap
            return Response.ok().entity("{\"Correct verification code! \":\"" + code + "\"}").build();


        } else {
            return Response.status(Response.Status.UNAUTHORIZED).entity("{\"message\":\"wrong verification code!!!\"}").build();

        }
    }

    @POST
    @Path("/{code}/{password}") // the user then sends the verification code alongside a new password
    public Response Respond(@PathParam("code") String code,@PathParam("password") String password) {//
        if (verifcodes.containsKey(code)) {//if the verification code exists in the hashmap
            String mail = verifcodes.get(code); // get the corresponding mail
            User user = repository.findById(mail).orElseThrow(); //get the user with the corresponding mail
            String newpassword = Argon2Utility.hash(password.toCharArray()); // hash the new given password
            User newuser = new User(user.getmail(), user.getfullname(), newpassword, user.getPermissionLevel()); //create new user entity with the newpassword
            repository.save(newuser); // update the new password
            verifcodes.remove(code);// remove the verification code from the hashmap
            return Response.ok().entity("{\"successful change of password for \":\"" + mail + "\"}").build();


        } else {
            return Response.status(Response.Status.UNAUTHORIZED).entity("{\"message\":\"wrong verification code!!!\"}").build();

        }
    }
}

