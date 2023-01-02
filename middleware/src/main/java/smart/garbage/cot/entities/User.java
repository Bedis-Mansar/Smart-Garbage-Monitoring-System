package smart.garbage.cot.entities;
import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;
import jakarta.json.bind.annotation.JsonbVisibility;
import smart.garbage.cot.util.Identity;

import java.io.Serializable;
import java.util.Objects;

@Entity
@JsonbVisibility(FieldPropertyVisibilityStrategy.class)
public class User implements Serializable, Identity { // User entity for database
    @Id
    private String mail; //email address
    @Column
    private String fullname;
    @Column
    private String password;
    @Column
    private Long permissionLevel;


    public User() {
    }

    public User(String mail, String fullname, String password,Long permissionLevel) {
        this.mail=mail;
        this.fullname=fullname;
        this.password = password;
        this.permissionLevel=permissionLevel;
    }



    public String getmail() {
        return mail;
    }
    public String getfullname() {
        return fullname;
    }
    public String getpassword() {
        return password;
    }
    public Long getPermissionLevel() {
        return permissionLevel;
    }

    public void setPermissionLevel(Long permissionLevel) {
        this.permissionLevel = permissionLevel;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Sensor)) {
            return false;
        }
        User user = (User) o;
        return Objects.equals(mail, user.mail);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(mail);
    }
    @Override
    public String getName() {
        return getmail();
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + mail + '\'' +
                ", fullname=" + fullname+

                '}';
    }

}