import {
  BackgroundImage,
  Button,
  Card,
  Drawer,
  Rating,
  ScrollArea,
  SimpleGrid,
  Text,
  TextInput,
  Title,
} from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import React from "react";

export default function MenuScreen() {
  const [opened, { open, close }] = useDisclosure(false);
  const [data, setData] = React.useState([]);
  const [tempData, setTempData] = React.useState([]);
  const [reviews, setReviews] = React.useState([]);
  const [search, setSearch] = React.useState("");

  React.useEffect(() => {
    fetch("/api/menu/read")
      .then((res) => res.json())
      .then((res) => setData(res));
  }, []);

  React.useEffect(() => {
    if (!tempData) return;
    fetch(`/api/review/read?item_id=${tempData?.id}`)
      .then((res) => res.json())
      .then((res) => setReviews(res));
  }, [tempData]);

  console.log(data);

  return (
    <BackgroundImage
      h={"100vh"}
      src="https://i.ibb.co/ZVkjkVk/AvAKW.png"
      radius="sm"
    >
      <div className="flex flex-col items-center justify-center h-full gap-3 p-10">
        <Title className="text-4xl text-white">Restaurant Menu</Title>
        <TextInput
          className="w-1/2 text-white"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          label="Search"
          placeholder="Search an item"
        />
        <ScrollArea h={"100%"} className="w-1/2">
          {search.length > 0 && data && (
            <SimpleGrid cols={1} className=" gap-10 mt-5">
              {data
                ?.filter(
                  (_) =>
                    _.name.toLowerCase().includes(search.toLowerCase()) ||
                    _.description.toLowerCase().includes(search.toLowerCase())
                )
                ?.map((_, index) => (
                  <Card key={index}>
                    <div className="flex justify-between">
                      <Text className="text-2xl " fw={700}>
                        {_?.name}
                      </Text>
                      <Text fw={700}>{parseFloat(_?.price).toFixed(2)}</Text>
                    </div>
                    <div></div>
                    <Button
                      onClick={() => {
                        open();
                        setTempData(_);
                      }}
                    >
                      View More
                    </Button>
                  </Card>
                ))}
            </SimpleGrid>
          )}
        </ScrollArea>

        {tempData && (
          <Drawer
            opened={opened}
            onClose={close}
            position="right"
            className="p-5 "
            size="xl"
            title={`Item Details`}
          >
            <div className="flex flex-col gap-3">
              <div className="flex flex-row justify-between ">
                <Title>
                  {tempData?.name} {tempData?.id}
                </Title>
                <Text>${parseFloat(tempData?.price).toFixed(2)}</Text>
              </div>
              <Text className="text-s">{tempData?.description}</Text>
              <Title>Reviews</Title>
              <ScrollArea h={"100%"} w="100%">
                <div className="flex flex-col gap-3 ">
                  {reviews.length > 0 &&
                    reviews?.map((_, index) => (
                      <Card className="flex justify-between" key={index + 1}>
                        <Text key={index}>{_?.comment}</Text>
                        <Rating readOnly defaultValue={_?.rating} />
                      </Card>
                    ))}
                </div>
              </ScrollArea>
            </div>
          </Drawer>
        )}
      </div>
    </BackgroundImage>
  );
}
