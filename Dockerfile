# build as
# sudo docker build -t custom_miniconda .
#
# run this image as
# coil@coil:~/Desktop/miniconda_docker_build$ sudo docker run --name custom_miniconda -i -t -p 8888:8888 -v "${PWD}:/notebooks" custom_miniconda
# or with docker compose demonized

FROM ubuntu:latest
RUN apt-get update && apt-get -y update
RUN apt-get install -y build-essential python3.8 python3-pip python3-dev wget
RUN pip3 -q install pip --upgrade
RUN pip install --user ipykernel
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b
ENV PATH=/root/miniconda3/bin:${PATH} 
RUN rm Miniconda3-latest-Linux-x86_64.sh
# create directory for notebooks
RUN mkdir /notebooks
WORKDIR /notebooks
COPY . /notebooks/
RUN conda env create -f environment.yml
SHELL ["conda", "run", "-n", "os", "/bin/bash", "-c"]
RUN conda list
#RUN conda install -c osmnx networkx folium
RUN conda update -y --all
RUN python -m ipykernel install --user --name=os
EXPOSE 8888
# start the jupyter notebook in server mode
CMD ["conda", "run", "-n", "os", "jupyter","notebook","--ip=0.0.0.0","--port=8888","--no-browser","--allow-root", "--notebook-dir=/notebooks","--NotebookApp.token=''","--NotebookApp.password=''"]