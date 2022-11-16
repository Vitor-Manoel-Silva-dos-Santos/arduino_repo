from server import app
import os
 
if __name__ == "__main__":
    os.chdir('server')
    app.run()