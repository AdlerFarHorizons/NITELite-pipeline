if aws s3 ls $CHECKPOINTED_OUTPUT | grep -q "PRE"; then
    echo "Found checkpointed output at $CHECKPOINTED_OUTPUT"
    aws s3 cp $CHECKPOINTED_OUTPUT ./data/output/ \
        --recursive \
        --exclude "referenced_images/*"
else
    echo "No checkpointed output found at $CHECKPOINTED_OUTPUT"
fi