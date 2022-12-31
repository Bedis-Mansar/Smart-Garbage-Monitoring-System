package smart.garbage.cot.controllers;

import jakarta.ejb.EJBException;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import smart.garbage.cot.entities.User;
import smart.garbage.cot.repositories.UserRepository;
import smart.garbage.cot.util.Argon2Utility;

@Stateless
@LocalBean
public class UserManager {
    @Inject
    private UserRepository userRepository; // repository to interact with the user database
    public User findByUsername(String username){ //takes username as input and returns the username
        final User user = userRepository.findById(username).orElseThrow();
        return user; // return the user with the username specified.
    }
    public User authenticate(final String username, final String password) throws EJBException {// method used in sign in, takes username and password as input and returns the user if authentication succeeds
        final User user = userRepository.findById(username).orElseThrow();
        if(user != null && Argon2Utility.check(user.getpassword(), password.toCharArray())){ //checks the password with the hashed password in the database
            return user;
        }
        throw new EJBException("Failed sign in with username: " + username + " [Unknown username or wrong password]");

    }


}
