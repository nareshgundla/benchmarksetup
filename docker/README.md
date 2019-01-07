Docker
Docker-machine (managing docker vm's)
●	docker-machine start
●	docker-machine stop
●	docker-machine ip
●	docker-machine ssh
●	docker-machine scp
●	docker-machine upgrade

docker  (ti --- interactive terminal)
●	run -ti ubuntu bash
●	run --net=host -ti ubuntu:14.04 bash
●	run -ti ubuntu:latest bash
●	ps (to view running containers)[--format=?, -a, -l]
●	commit container_id
    ○	tag IMAGE_ID custom_image_name
●	commit container_name cutom_image_name
●	run --rm -ti ubuntu sleep 5
●	run -ti ubuntu bash -c "sleep 5;echo all done"
●	run --name container_name -d -ti ubuntu bash
●	attach container_name
●	Add another process and attach to the same container
    ○	exec -ti container_name bash
●	logs container_name
●	kill container_name
●	rm container_name
●	inspect
●	Limits : --memory, --cpu-shares, --cpu-quota
●	Network Connectivity:(-p inside_cont_port:outside_container_port/protocol(udp/tcp) )
    ○	run --rm -ti -p 45678:45678 -p 45679:45679 --name container_name ubuntu bash
    ○	Connect to the port using the ip address(docker-machine ip)
    ○	Allocating port dynamically
        ■	Ignore outside port and find the outside port after container is launched by
    ○	Docker port container_name
●	Linking Connection between containers
    ○	One way connection from server to client
    ○	Linking automatically assigns hostname and ip mapping to client while creating the container
    ○	run --rm -ti --link server_container_name --name client_container_name ubuntu bash
    ○	Connect to server using server_container_name and port
    ○	NOTE: links might break when container restart; solution :use private network
●	Docker Private Networks
    ○	network create network-name
    ○	run --rm -ti --net=network_name --name server ubuntu bash
●	Binding ip address (host to docker)
    ○	run -p 127.0.0.1:1234:1234/tcp
●	Volumes/Virtual Disks
    ○	Volumes are temporary and exists as long as the containers which are using it are alive
    ○	run -ti -v /shared_data --name container_1 ubuntu bash
    ○	run -ti --volumes-from container_1 ubuntu bash
●	Registries
    ○	Search image-name
    ○	Login (hub.docker.com)
    ○	Docker pull image:tag
    ○	Docker tag new_name user_name/name:tag
    ○	Docker push user_name/name:tag
●	Dockerfiles
    ○	Processes you start on one line will not be running on the next line
    ○	Sample file
        FROM start-image (always first line)
		Keywords :
        RUN,  CMD, ADD, MAINTAINER, ENTRYPOINT, EXPOSE, VOLUME,   WORKDIR, USER, ENV
●	BUILDING docker
    ○	docker build -t name .


Docker toolbox (install)(1.11.2)
●	Pre check: virtualization should be enabled in task manager->performance

Docker Flow::
●	Image
    ○	docker images
    ○	Referring to docker image [repo:tag or image id]
    ○	pull
    ○	push
    ○	rmi IMAGE-name:tag

IMAGE->run->CONTAINER(with process)-->STOPPED_CONTAINER-->commit-->IMAGE

Notes
●	Don't let your container fetch dependencies when they start
●	Don't leave important things in un-named stopped containers
DOCKER internals:
●	Written in GO
●	Manages kernel features
    ○	Uses cgroup to contain processes
    ○	Uses namespace to contain network
    ○	Uses copy-on-write filesystems to build images
●	Makes scripting distributed systems easy
●	Docker is two program: a client and server
    ○	The server receives command over socket (either over a network or through a file)
    ○	The client can even run inside docker itself (can run anywhere and connects to docker server)
●	Docker uses bridges to create virtual networks in your computer
    ○	These are software switches
    ○	They control the ethernet layer
●	Docker creates firewall rules to move packets between networks
    ○	NAT
    ○	For info [ iptables -n -L -t nat ]
    ○	Exposing a port  -- really is port-forwarding (firewall rule -- DNAT]
●	Namespaces
    ○	They allow processes to be attached to private network segments
    ○	Thes private networks are bridged into a shared network with the rest of the containers
    ○	Containers have virtual network cards
    ○	Containers get their own copy of the networking stack
●	In Docker, your container starts with an init process and vanishes when that process exists
    ○	Init cleans up abandoned processes
    ○	Communication between processes is limited to processes in this group (cgroup)
    ○	Containers can't see processes in other cgroups
    ○	Docker-machine ::::: /proc (shows  proc on that host machine)
●	Dockers uses the concept of logical storage devices (linux vfs)
    ○	The content of layers are moved between containers in gzip files
    ○	Containers are independent of storage engine
    ○	Any container can be loaded anywhere
    ○	It is possible to run out of layers on some of the storage engines
●	Docker Registry
    ○	Is a program, Stores layers and images
●	Docker Compose
    ○	Single machine co-ordination
    ○	Designed for testing and development
    ○	Brings up all containers, volumes, network, etc with one command
SECRET OF DOCKER: COWs(copy-on-write)
Other orchestration systems
●	Kubernetes
    ○	Containers runs programs
    ○	Pods group containers together
    ○	Services makes pods available to others
    ○	Makes scripting large operations possible with the kubectl command
    ○	Very flexible overlay networking
    ○	Built-in service discovery
●	Amazon EC2 container service (ECS)
    ○	TASK definitions
        ■	Define a set of containers that always run together
    ○	Tasks
        ■	Actually makes container run right now
    ○	Services and exposes it to Net

Assignment:
●	Get one service to run in docker
●	Learn more about dockerfiles
●	Run a production service on your laptop
●	Make a personal development image




