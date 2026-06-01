(in-package :bis)


;;;; configure allegro-cache


(open-file-database "allegro-cache-db" 
                    :if-does-not-exist :create
                    :if-exists :open)  


