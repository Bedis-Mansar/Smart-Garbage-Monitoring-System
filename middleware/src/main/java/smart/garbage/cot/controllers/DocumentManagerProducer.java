package smart.garbage.cot.controllers;
import jakarta.nosql.document.DocumentCollectionManager;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.Disposes;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Inject;

@ApplicationScoped
public class DocumentManagerProducer { //The document manager is the one responsable for the database conenction.
    @Inject
    @ConfigProperty(name = "document") // Inject database settings from system variables to ensure the connection
    private DocumentCollectionManager manager;

    @Produces
    public DocumentCollectionManager getManager() {
        return manager;
    }

    public void destroy(@Disposes DocumentCollectionManager manager) { //Get rid of the manager
        manager.close();
    }
}
