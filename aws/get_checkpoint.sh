if aws s3 ls $EXISTING_OUTPUT | grep -q "PRE"; then
    echo "Found checkpointed output at $EXISTING_OUTPUT"
    aws s3 cp $EXISTING_OUTPUT ./data/output/ \
        --recursive \
        --exclude "referenced_images/*"
else
    echo "No checkpointed output found at $EXISTING_OUTPUT"
fi