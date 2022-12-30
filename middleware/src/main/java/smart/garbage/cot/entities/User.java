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
    private String username;

    @Column
    private String password;
    @Column
    private Long permissionLevel;


    public User() {
    }

    public User(String username, String password,Long permissionLevel) {
        this.username=username;
        this.password = password;
        this.permissionLevel=permissionLevel;
    }



    public String getusername() {
        return username;
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
        return Objects.equals(username, user.username);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(username);
    }
    @Override
    public String getName() {
        return getusername();
    }

    @Override
    public String toString() {
        return "Sensor{" +
                "id='" + username + '\'' +
                ", value=" + password +

                '}';
    }

}