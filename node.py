#import necessary libraries
from ChainEngine import Connection, PyChain, SSHKey
import json

def Node(PORT, PUBLIC_KEY, PRIVATE_KEY, HOST, NAME, HOST_PORT=None):
    # Define our connection
    conn = Connection(private_key=PRIVATE_KEY, public_key=PUBLIC_KEY, host=HOST, host_port=HOST_PORT)
    
    # Create first node 
    node = PyChain(NAME, conn, PORT)
    
    # Add initial data to blockchain
    node.insert({'data': []})
    
    return node.daemon()

# Call the Node function with the loaded configuration
if __name__ == '__main__':
  with open("node.json", "r") as file:
      config = json.load(file)
  
  NAME = config['NAME']
  PORT = int(config['PORT'])
  PUBLIC_KEY = config['PUBLIC_KEY']
  PRIVATE_KEY = config['PRIVATE_KEY']
  HOST = config['HOST']
  HOST_PORT = config.get('HOST_PORT',None)
  Node(PORT, PUBLIC_KEY, PRIVATE_KEY, HOST, NAME, HOST_PORT=HOST_PORT)
