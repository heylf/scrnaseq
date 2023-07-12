# Base image
FROM python:3.9.7

# Create a non-root user
RUN useradd -m plexer_user
USER plexer_user

# Set working directory
WORKDIR /home/plexer_user

# Copy the Python script to the working directory
COPY plexer.py .

# Install dependencies
RUN python3 -m venv venv
ENV PATH="/home/plexer_user/venv/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install muon

# Set default command
CMD ["bash"]