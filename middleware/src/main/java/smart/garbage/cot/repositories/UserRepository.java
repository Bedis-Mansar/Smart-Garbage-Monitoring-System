package smart.garbage.cot.repositories;
import jakarta.nosql.mapping.Repository;
import smart.garbage.cot.entities.User;
import java.util.stream.Stream;
public interface UserRepository  extends Repository <User, String> { // repository containing the methods for interacting with SensorDB entity in mongodb
    Stream<User> findAll();
    Stream<User> findbyusername();

}
