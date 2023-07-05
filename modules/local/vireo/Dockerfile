# Base image
FROM python:3.9.7

# Create a non-root user
RUN useradd -m vireo_user
USER vireo_user

# Set working directory
WORKDIR /home/vireo_user

# Install dependencies
RUN python3 -m venv venv
ENV PATH="/home/vireo_user/venv/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install -U vireoSNP

# Set default command
CMD ["bash"]