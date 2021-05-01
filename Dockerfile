FROM continuumio/miniconda3
COPY environment_bitz.yml environment.yml
RUN conda env create -f environment.yml
ENV PATH /opt/conda/envs/bitz/bin:$PATH

CMD ["/opt/project/scripts/test.sh"]
