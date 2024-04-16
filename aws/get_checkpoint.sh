if [ -z "$(aws s3 ls $CHECKPOINTED_OUTPUT)" ]; then
    aws s3 cp $CHECKPOINTED_OUTPUT ./data/output/ \
        --recursive \
        --exclude "referenced_images/*"
fi