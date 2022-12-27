package smart.garbage.cot.repositories;
import jakarta.nosql.mapping.Repository;
import smart.garbage.cot.entities.SensorDB;

import java.util.stream.Stream;
public interface SensorDBRepository  extends Repository <SensorDB, String> { // repository containing the methods for interacting with SensorDB entity in mongodb
    Stream<SensorDB> findAll();

}
