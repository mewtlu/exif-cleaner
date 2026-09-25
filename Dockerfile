ARG PYTHON_VERSION=3.14
FROM public.ecr.aws/lambda/python:${PYTHON_VERSION}

COPY requirements.txt ${LAMBDA_TASK_ROOT}

RUN pip install --no-cache-dir -r requirements.txt

COPY exif_cleaner.py handler.py ${LAMBDA_TASK_ROOT}

CMD [ "handler.handler" ]
